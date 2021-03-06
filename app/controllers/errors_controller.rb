class ErrorsController < ApplicationController

  def not_found
    respond_to do |format|
      format.json { render json: { status: 404, error: 'Not Found' } }
      format.html { render(status: 404) }
    end
  end

  def unprocessable
    respond_to do |format|
      format.json { render json: { status: 422, error: 'Unprocessable Entity' } }
      format.html { render(status: 422) }
    end

  end

  def internal_server_error
    respond_to do |format|
      format.json { render json: { status: 500, error: 'Internal Server Error' } }
      format.html { render(status: 500) }
    end

  end

  def service_unavailable
    respond_to do |format|
      format.json { render json: { status: 503, error: 'Service Unavailable' } }
      format.html { render(status: 503) }
    end

  end
end
