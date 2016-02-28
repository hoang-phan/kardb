class PatchesController < ApplicationController
  def upload_all
    PatchesUploader.perform_async
    redirect_to :back, notice: 'Uploaded'
  end

  def create
    patch = Patch.find_or_create_by(version: Time.current.strftime('%Y%m%d').to_i)
    Song.where(patch: nil).update_all(patch_id: patch.id)
    PatchUploader.perform_async(patch.id)
    redirect_to :back, notice: 'Uploaded'
  end
end
