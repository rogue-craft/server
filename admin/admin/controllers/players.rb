Admin::Admin.controllers :players do
  get :index do
    @title = "Players"
    @players = Model::Player.all
    render 'players/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'player')
    @player = Model::Player.new
    render 'players/new'
  end

  post :create do
    @player = Model::Player.new(params[:model_player])
    if @player.save
      @title = pat(:create_title, :model => "player #{@player.id}")
      flash[:success] = pat(:create_success, :model => 'Model::Player')
      params[:save_and_continue] ? redirect(url(:players, :index)) : redirect(url(:players, :edit, :id => @player.id))
    else
      @title = pat(:create_title, :model => 'player')
      flash.now[:error] = pat(:create_error, :model => 'player')
      render 'players/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "player #{params[:id]}")
    @player = Model::Player[params[:id]]
    if @player
      render 'players/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'player', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "player #{params[:id]}")
    @player = Model::Player[params[:id]]
    if @player
      if @player.update(params[:model_player])
        flash[:success] = pat(:update_success, :model => 'Player', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:players, :index)) :
          redirect(url(:players, :edit, :id => @player.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'player')
        render 'players/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'player', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Players"
    player = Model::Player[params[:id]]
    if player
      if player.delete
        flash[:success] = pat(:delete_success, :model => 'Player', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'player')
      end
      redirect url(:players, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'player', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Players"
    unless params[:player_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'player')
      redirect(url(:players, :index))
    end
    ids = params[:model_player_ids].split(',').map(&:strip)
    players = Model::Player.fetch(ids)
    
    if players.each(&:delete)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Players', :ids => "#{ids.join(', ')}")
    end
    redirect url(:players, :index)
  end
end
