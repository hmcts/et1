RSpec.shared_examples 'it parses dates' do |*dates|
  dates.each do |date|
    subject { described_class.new Claim.new }

    describe 'validation' do
      context "when no #{date} has been given" do
        before { subject.valid? }

        specify "there are no date errors on #{date}" do
          expect(subject.errors[date]).to be_empty
        end
      end

      context "when a 'blank' #{date} has been given" do
        before do
          subject.send "#{date}=", ''
          subject.valid?
        end

        specify "there are no date errors on #{date}" do
          expect(subject.errors[date]).to be_empty
        end

        it "it does not update the value of #{date}" do
          expect(subject.send(date)).to be nil
        end
      end

      describe 'handling invalid dates' do
        let(:model_translation_path) do
          "activemodel.errors.models.#{described_class.model_name.name}.attributes.#{date}.invalid"
        end

        context "when a non-numeric #{date} has been given" do
          before do
            subject.send "#{date}=", 'wat/da/fuq'
            subject.valid?
          end

          it "adds a validation error to #{date}" do
            expect(subject.errors[date]).to include I18n.t(model_translation_path)
          end
        end

        context 'when a numeric date with out of bounds segments has been given' do
          before do
            subject.send "#{date}=", '64/32/2014'
            subject.valid?
          end

          it "adds a validation error to #{date}" do
            expect(subject.errors[date]).to include I18n.t(model_translation_path)
          end
        end

      end
    end
  end
end
