# { render json: { payer_html: render_to_string(partial: "bills/payer", formats: :html, locals: {  member: Member.find(params[:member_id])} )} }
json.payer_html render(
    partial: 'bills/payer',
    formats: :html,
    locals: {
      member: @member,
      split: @bill.split,
      bill: @bill,
      payer: Payer.new
    }
  )
