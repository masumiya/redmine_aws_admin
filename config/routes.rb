Rails.application.routes.draw do
  resources :projects do
    resources :instances do
      member do
        get  'show'
        get  'start'
        get  'stop'
        get  'reboot'
      end

      collection do
        get  'reload'
      end
    end
  end
  match '*not_found' => 'application#render_404'
end