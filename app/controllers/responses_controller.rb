class ResponsesController < ApplicationController
  def show
    @creative_qualities = CreativeQuality.all
    @response = Response
      .includes(question_responses: [question_choice: [question: :question_choices]])
      .find(params[:id])
  end

  def index
    @responses = Response.all
  end
end
