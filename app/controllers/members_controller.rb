class MembersController < ApplicationController
  def create
    @member = Member.new(member_params)
    @split = Split.find(params[:split_id])

    if @member.save
      @split.members << @member
      redirect_to split_add_members_path(@split)
    else
    end
  end

  def contact_lookup
    contacts = current_user.contacts
                    .where("members.phone_number LIKE ?", "%#{params[:phone]}%")
                    .where("lower(members.name) LIKE ?", "%#{params[:name].downcase}%")

    split = Split.find(params[:split_id])
    contacts = contacts - split.members
    member_matched_by_phone = Member.find_by(phone_number: params[:phone])

    render json: {
      contacts: render_to_string(partial: "splits/members_selector", locals: { members: contacts }, formats: [:html]),
      member_matched_by_phone:
    }, status: :ok
    # @member = Member.find_by(phone_number: params[:phone_number])
    #
    # if @member
    #   render json: @member, status: :ok
    # else
    #   render json: { error: "Member not found" }, status: :not_found
    # end
  end

  private

  def member_params
    params.require(:member).permit(:name, :phone_number)
  end
end
