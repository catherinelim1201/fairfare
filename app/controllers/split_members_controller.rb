class SplitMembersController < ApplicationController
  def create
    nickname = params[:nickname]
    # Check if member exist (with phone_number)
    @member = Member.find_by(phone_number: params[:phone_number])
    # If member doesn't exist, create member
    @member = Member.create(phone_number: params[:phone_number]) if @member.nil?

    # Make member a contact
    @contact = Contact.create(
      user: current_user,
      member: @member,
      nickname: nickname
    )

    # Add contact as a split member
    @split_member = SplitMember.new(split_member_params)
    @split_member.member = @member

    @available_contacts = []

    if @split_member.save
      redirect_to split_add_members_path(@split_member.split), notice: "#{nickname} added as contact!"
    else
      @split = Split.find(params[:split_id])
      render 'splits/add_members', status: :unprocessable_entity
    end
  end

  def destroy
    @split = Split.find(params[:split_id])
    @split_member = SplitMember.find(params[:id])
    @split_member.destroy
    head :ok
  end

  private

  def split_member_params
    params.require(:split_member).permit(:split_id)
  end
end
