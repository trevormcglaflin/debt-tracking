class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
  end

  def show
    @entity = Entity.find(params[:id])
  end

  def new
    @entity = Entity.new
  end

  def create
    @entity = Entity.new(entity_params)

    if @entity.save
      redirect_to @entity
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @entity = Entity.find(params[:id])
  end

  def update
    @entity = Entity.find(params[:id])

    if @entity.update(entity_params)
      redirect_to @entity
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entity = Entity.find(params[:id])
    @entity.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def entity_params
      params.require(:entity).permit(:name, :email, :naics_code)
    end
end
