import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-people"
export default class extends Controller {
  static targets = ["checkbox", "form"]
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
      this.checkboxTarget.classList.add("green")
    }
  }

  toggle(event) {
    event.preventDefault()
    // console.log("AJAX")

    if (!this.hasItemMemberValue) {

      this.checkboxTarget.classList.remove("grey")
      this.checkboxTarget.classList.add("green")

      fetch(this.formTarget.action, {
        method: "POST",
        headers: { "Accept": "application/json" },
        body: new FormData(this.formTarget)
      })
        .then(response => {
          return response.json()
        })
        .then((data) => {
          console.log("data", data)
        })
    }

    if (this.hasPayerValue === 'true') {

      this.checkboxTarget.classList.remove("green")
      this.checkboxTarget.classList.add("grey")

      // THIS GREEN->GREY TOGGLE IS NOT WORKING BUT THE DELETE IS WORKING ????????


      // fetch(this.destroy_url, {
      //   method: "DELETE",
      //   headers: { "Accept": "application/json" },
      //   // body: new FormData(this.formTarget)
      // })
      //   .then(response => {
      //     return response.json()
      //   })
      //   .then((data) => {
      //     console.log("data", data)
      //   })
    }
  }
}
