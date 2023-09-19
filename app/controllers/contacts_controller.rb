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
            locals: {
              contacts: @contacts,
              split: @split
            },
            formats: [:html]
          )
        }
      end
    end
  end

  def index
    # user = User.requests_for(current_user)
    @split_ids = current_user.split_ids

    @splits = []

    @split_ids.each do |split_id|
      @split = Split.find(split_id)
      @splits << @split

      @splitmember = SplitMember.find_by(split_id: split_id)
      @member = Member.find(@splitmember.member_id)
      @contact = Contact.find(@member.id)
      raise

    end

    # @split_members = []
    # @split_member_ids = @split.split_member.id
    # @split_member_ids.each do |split_member_id|
    #   @split_members << @split_member_id
    # end
    # @splits.user_id = User.requests_for(current_user)

    # @split.user_id = Split.find(params[:split_id])
    # @split.user = current_user

    # @contacts = Contact.all
    # @split_members = SplitMember.all
    # @splits = Split.all
  end
end
