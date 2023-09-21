class ContactsController < ApplicationController
  def filter
    nickname = params[:nickname]

    @contacts = current_user.contacts.where("nickname ILIKE ?", "%#{nickname}%")
    @split = Split.find(params[:split_id])

    respond_to do |format|
      format.json do
        render json: {
          contacts: render_to_string(
            partial: "splits/contact_list",
            locals: { available_contacts: @contacts, split: @split },
            formats: [:html]
          )
        }
      end
    end
  end
end
