class MembersController < ApplicationController
  def create
    raise
    # find if there is a member with this number
      # if not, create the member

    # check if member is a contact
      # if not, add as contact

    # add to split

    @member = Member.new(member_params)
    @split = Split.find(params[:split_id])

    if @member.save
      @split.members << @member
      redirect_to split_add_members_path(@split)
    else
    end
  end

  private

  def member_params
    params.require(:member).permit(:phone_number)
  end
end
