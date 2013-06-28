BPDoc::Application.routes.draw do
  resources :document_directives
  resources :directives do
    resources :documents  # документы на основании директивы
    get :autocomplete, :on => :collection
  end
  resources :bapps, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :iresources, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :users, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :workplaces, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :activities
  resources :bapps
  resources :bproce_workplaces, :only => [:new, :create, :destroy, :show]
  resources :bproce_documents, :only => [:show]
  resources :bproce_business_roles, :only => [:show]
  resources :bproce_iresources, :only => [:new, :create, :destroy, :show, :edit, :update]
  resources :bproce_bapps, :only => [:create, :destroy, :show, :edit, :update]
  resources :bproces do
    resources :bapps
    collection do
      get :manage
      post :rebuild
    end
  end
  get 'bproces/tags/:tag', to: 'bproces#index', as: :tag
  get 'bapps/tags/:tag', to: 'bapps#index', as: :tag
  get 'documents/tags/:tag', to: 'documents#index', as: :tag
  #get 'tags/:tag', to: 'bproces#index', as: :tag
  #get 'tags', to: 'bproces#index'
  resources :business_roles
  resources :categories
  resources :documents
  resources :iresources
  resources :roles, only: [:index, :show]
  resources :terms
  resources :user_workplaces
  resources :user_business_roles, :only => [:new, :create, :destroy]

  match '/bproceses' => 'bproces#list', :via => :get  # получение полного списка процессов
  match '/bproces/:id/card' => 'bproces#card', :via => :get  # карточка процесса
  match '/bproces/:id/doc' => 'bproces#doc', :via => :get  # заготовка описания процесса
  match '/workplaces/switch' => 'workplaces#switch', :via => :get  # подключения рабочих мест
  resources :workplaces
  
  match '/about' => 'pages#about', :via => :get
  get 'pages/about'
  devise_for :users
  devise_scope :users do
    get "sign_in", :to => "devise/sessions#new"
    get "sign_out", :to => "devise/sessions#destroy"
    get "sign_up", :to => "devise/registrations#new"
  end
  resources :users, :only => [:index, :show, :edit, :update]
  root :to => "home#index"

end
