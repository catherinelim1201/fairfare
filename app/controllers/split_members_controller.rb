class SplitMembersController < ApplicationController
  def create
    @member = Member.find_by(phone_number: member_params[:phone_number])
    if @member.present?
    else
      @member = Member.create(member_params)
    end

    @split = Split.find(params[:split_id])

    if @member.save
      @split.members << @member
      redirect_to split_add_members_path(@split)
    else
      @available_contacts = current_user.contacts - @split.members
      render "splits/add_members", status: :unprocessable_entity
    end
  end

  def destroy
    @split = Split.find(params[:split_id])

    return if @split.user != current_user

    SplitMember.find_by(split: @split, member_id: params[:member_id]).destroy

    redirect_to split_add_members_path(@split)
  end

  private

  def member_params
    params.require(:member).permit(:name, :phone_number)
  end
end
