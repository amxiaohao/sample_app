Rails.application.routes.draw do
  #把发给 /static_pages/home 的请求映射到 StaticPages 控制器的 home 动作上
  root 'static_pages#home'
  get  '/help',   to: 'static_pages#help'
  get  '/about',  to: 'static_pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
