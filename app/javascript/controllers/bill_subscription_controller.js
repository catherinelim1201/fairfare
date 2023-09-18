import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="bill-subscription"
export default class extends Controller {
  static values = { billId: Number }

  connect() {
    this.channel = createConsumer().subscriptions.create(
        { channel: "BillRoomChannel", id: this.billIdValue },
        { received: (data) => {
          const memberTags = document.querySelector(`#item-${data.item_id}-member-tags`)
          memberTags.innerHTML = data.member_tag_html;

          const membersForm = document.querySelector(`#item-${data.item_id}-member-select`)
          membersForm.innerHTML = data.item_members_form_html;
        }
        }
    )
    console.log(`connected to ${this.billIdValue}`)
  }
}
