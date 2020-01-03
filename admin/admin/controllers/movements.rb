Admin::Admin.controllers :movements do
  get :index do
    @title = "Movements"
    @movements = Model::Movement.all
    render 'movements/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'movement')
    @movement = Model::Movement.new
    render 'movements/new'
  end

  post :create do
    @movement = Model::Movement.new(params[:model_movement])
    if @movement.save
      @title = pat(:create_title, :model => "movement #{@movement.id}")
      flash[:success] = pat(:create_success, :model => 'Model::Movement')
      params[:save_and_continue] ? redirect(url(:movements, :index)) : redirect(url(:movements, :edit, :id => @movement.id))
    else
      @title = pat(:create_title, :model => 'movement')
      flash.now[:error] = pat(:create_error, :model => 'movement')
      render 'movements/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "movement #{params[:id]}")
    @movement = Model::Movement[params[:id]]
    if @movement
      render 'movements/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'movement', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "movement #{params[:id]}")
    @movement = Model::Movement[params[:id]]
    if @movement
      if @movement.update(params[:model_movement])
        flash[:success] = pat(:update_success, :model => 'Movement', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:movements, :index)) :
          redirect(url(:movements, :edit, :id => @movement.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'movement')
        render 'movements/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'movement', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Movements"
    movement = Model::Movement[params[:id]]
    if movement
      if movement.delete
        flash[:success] = pat(:delete_success, :model => 'Movement', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'movement')
      end
      redirect url(:movements, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'movement', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Movements"
    unless params[:movement_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'movement')
      redirect(url(:movements, :index))
    end
    ids = params[:model_movement_ids].split(',').map(&:strip)
    movements = Model::Movement.fetch(ids)
    
    if movements.each(&:delete)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Movements', :ids => "#{ids.join(', ')}")
    end
    redirect url(:movements, :index)
  end
end
