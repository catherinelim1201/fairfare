import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payer-dropdown"
export default class extends Controller {
  static targets = ["checkbox", "form"]
  static values = {
    splitId: String,
    billId: String,
    payerId: String,
    hasPayer: String
  }

  connect() {
    // this.create_url = `/splits/${this.splitIdValue}/bills/${this.billIdValue}/payers`
    this.destroy_url = `/splits/${this.splitIdValue}/bills/${this.billIdValue}/payers/${this.payerIdValue}`

    if (this.hasPayerValue === 'true') {
      console.log('hasPayer', this.hasPayerValue)
      this.checkboxTarget.classList.add("added-green")
    }
  }

  toggle(event) {
    event.preventDefault()

    // console.log(event.target.action);

    if (this.hasPayerValue === 'false') {

      // this.checkboxTarget.classList.add("add-green")

      fetch(this.formTarget.action, {
        method: "POST",
        headers: { "Accept": "application/json" },
        body: new FormData(this.formTarget)
      })
        .then(response => {
          return response.json()
        })
        .then((data) => {
          this.element.outerHTML = data.payer_html;
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
      .then(response => response.json())
      .then(data => {
        this.element.outerHTML = data.payer_html;
      })
  }
}
