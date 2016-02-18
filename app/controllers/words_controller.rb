class WordsController < ApplicationController
  before_action :set_word, only: :update

  def update
    @word.update(word_params)
    redirect_to :back
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:note, :duration, :processed_at)
  end
end