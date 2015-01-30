ActiveAdmin.register Claim do
  filter :submitted_at

  # no edit, destory, create, etc
  config.clear_action_items!
  actions :index, :show

  controller { defaults finder: :find_by_reference }

  # Index page
  index download_links: false do
    column :reference do |claim|
      link_to claim.reference, admin_claim_path(claim.reference)
    end

    column :fee_group_reference

    column(:missing_payment) do |claim|
      if claim.immutable? && claim.fee_to_pay? && !claim.payment_present?
        'Yes'
      else
        'N/A'
      end
    end

    column(:state) { |claim| claim.state.humanize }
  end

  # Show
  show title: :reference do
    panel 'Metadata' do
      attributes_table_for claim do
        row('Submitted to JADU') { |c| c.submitted? ? c.submitted_at : 'No' }
        row('Payment required')  { |c| c.fee_to_pay? ? 'Yes' : 'No' }
        row('Payment received')  { |c| c.payment_present? ? 'Yes' : 'No' }
      end
    end

    panel 'Events' do
      table_for claim.events do
        column :event
        column :actor
        column :message
        column :created_at
      end
    end
  end
end
