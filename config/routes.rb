Rails.application.routes.draw do

  resource :guide, only: :show

  resource :user_session, only: %i<create update>, path: :application do
    member do
      get 'reminder'
      get 'returning'
    end
  end

  scope :apply do
    resource :claim_review, only: %i<show update>, path: :review

    resource :claim_confirmation, only: :show, path: :confirmation do
      get 'generated_claim', on: :member
    end

    resource :claim, only: :create, path: "/" do
      resource :payment, only: %i<show update>, path: :pay do
        member do
          %i<success decline>.each do |result|
            get result, to: "payments##{result}", as: result
          end
        end
      end

      %w<claimants respondents>.each do |page|
        resource :"additional_#{page}", only: %i<show update>,
          controller: :multiples, page: "additional-#{page}",
          path: "additional-#{page}"
      end

      ClaimTransitionManager.pages.each do |page|
        resource page.underscore, only: %i<show update>, controller: :claims,
          page: page, path: page
      end
    end
  end

  root to: 'claims#new'

  get 'ping' => 'ping#index'
end
