class WorklistItemsController < ApplicationController
  before_action :set_worklist_item, only: [:edit, :update, :destroy]

  # GET /worklist_items/1/edit
  def edit
  end

  # PATCH/PUT /worklist_items/1
  # PATCH/PUT /worklist_items/1.json
  def update
    respond_to do |format|
      if @worklist_item.update(worklist_item_params)
        format.html { redirect_to @worklist_item, notice: 'Worklist item was successfully updated.' }
        format.json { render :show, status: :ok, location: @worklist_item }
      else
        format.html { render :edit }
        format.json { render json: @worklist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /worklist_items/1
  # DELETE /worklist_items/1.json
  def destroy
    @worklist_item.destroy
    respond_to do |format|
      format.html { redirect_to worklist_items_url, notice: 'Worklist item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_worklist_item
      @worklist_item = WorklistItem.find(params[:id])
    end

    def worklist_item_params
      params[:worklist_item]
    end
end
