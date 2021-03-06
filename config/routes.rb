Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors do
      collection do
        post :update_positions
      end
    end
    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
    get 'sale_reports' => 'vendor_settings#sale_reports'
    get 'block_fans' => 'vendor_settings#block_fans'
    get 'change_status' => 'vendor_settings#change_status'
  end

  resources :vendors do
    collection do
      post :update_positions
    end
  end
  get 'vendor_settings' => 'vendor_settings#edit'
  patch 'vendor_settings' => 'vendor_settings#update'

end