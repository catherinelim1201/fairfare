class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def test
    @split = Split.find(split_id)

    #....

    render json: {
      user_1: {
        user_2: 123456,
        user_3: 123456,
      },
      user_2: {
        user_1: 13232
      }
    }
  end

  def home
    if user_signed_in?
      if code
        session.delete(:code)
        return redirect_to invite_splits_path(code:)
      end

      @splits = Split.joins(:members).where(
        members: { user_id: current_user.id }).or(Split.where(user_id: current_user.id))

      render 'pages/dashboard'
    else
      redirect_to new_user_session_path
    end
  end

  private

  def code
    @code ||= session[:code]
  end
end
