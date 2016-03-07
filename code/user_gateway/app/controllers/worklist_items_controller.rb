class WorklistItemsController < ApplicationController
  def index
    @worklist_items = mq_request 'worklist_item.index', 'worklist_item.indexed', role_id: params[:role_id]
    @worklist_items = @worklist_items['worklist']
  end

  def edit
    @worklist_item = mq_request 'worklist_item.show', 'worklist_item.showed', id: params[:id]
  end

  def update
    mq_request 'worklist_item.update', 'worklist_item.updated', id: params[:id], worklist_item: params[:worklist_item]
    redirect_to worklist_items_url, notice: 'Worklist item was successfully submitted.'
  end

  def destroy
    mq_request 'wfms.user.destroy', 'wfms.user.destroyed', id: params[:id]
    redirect_to worklist_items_url, notice: 'Worklist item was successfully destroyed.'
  end

  private

  def worklist_item_params
    params[:worklist_item]
  end
end
