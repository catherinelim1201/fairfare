import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-contacts"
export default class extends Controller {
  static targets = ["form", "contacts"]
  static values = {
    splitId: String
  }

  connect() {
    // console.log(this.splitIdValue);
    this.url = `/splits/${this.splitIdValue}/contacts/filter`
    this.nickname = '';
  }

  filterByNickname(event) {
    this.nickname = event.target.value
    this.filterContacts()
  }

  filterContacts() {
    fetch(`${this.url}?nickname=${this.nickname}`, { headers: { "Accept": "application/json" } })
      .then(response => response.json())
      .then((data) => {
        // console.log(data.contacts)
        this.contactsTarget.innerHTML = data.contacts
      })
  }
}
