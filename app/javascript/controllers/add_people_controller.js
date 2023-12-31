import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-people"
export default class extends Controller {
  static targets = ["checkbox", "form", "everyone"]
  static values = {
    splitId: String,
    billId: String,
    itemId: String,
    itemMemberId: String,
    hasItemMember: Boolean
  }

  connect() {
    // this.create_url = `/splits/${this.splitIdValue}/bills/${this.billIdValue}/items/${this.itemIdValue}/item_members`
    this.destroy_url = `/splits/${this.splitIdValue}/bills/${this.billIdValue}/items/${this.itemIdValue}/item_members/${this.itemMemberIdValue}`

    if (this.hasItemMemberValue) {
      console.log('hasItemMember', this.hasItemMemberValue)
      this.checkboxTarget.classList.add("added-green")
    }
  }

  toggle(event) {
    event.preventDefault()
    console.log("AJAX")

    if (!this.hasItemMemberValue) {

      fetch(this.formTarget.action, {
        method: "POST",
        headers: { "Accept": "application/json" },
        body: new FormData(this.formTarget)
      })
    }
  }

  delete(event) {
    event.preventDefault()

    fetch(event.currentTarget.href, {
      method: 'DELETE',
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        Accept: 'application/json'
      }
    })
  }

  everyone(event) {
    event.preventDefault()

    this.everyoneTarget
  }
}
