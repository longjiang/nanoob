# Nanoob

Nanoob is company management system for

* Posts

* Backlinks 

# Users
````
User
````
## User
````
username
email
````


# Businesses
````
Business
website
````
## Business
````
Product
Language
````

* `Product` : Rideaux, Poignées
* `Language` : Fr, En, It

## Website
````
business_id
platform
url
````

# Backlinks

## Model

````
Backlinks::Partner
Backlinks::Request
Backlinks::Link

````

### Backlinks::Partner

````
Title
Category
Domain
name
email
url
````

* `Title`: Title of the website 
* `Category`: Category of the website (available categories depends on product line) 
* `Domain`: Domain name (extract from url without https://)
* `name`: Contact name (used for sending request, and reminders)
* `email`: Contact email (used for sending request and reminders)
* `url`: Url of web contact form if any


### Backlinks::Request
````
partner_id
business_id
subject
body
mode 
sent_at
status
user_id
created_at
updated_by
updated_at
````

* `Partner_id`: Partner to whom request is sent
* `Business_id`: Business (Rideaux, Poignées...)
* `Subject`: Subject of email if sent by email / or web form if applicable
* `Body`: Body of email / web form
* `Mode`: email / web form
* `sent_at`: first contact
* `Status`: One of the following
  * Draft (request has not been sent yet)
  * Sent (request sent)
  * Canceled (request canceled by user)
  * Paid (Partner accepts paid backlinks)
  * Rejected (Partner rejected the request)
  * In Progress (Partner asked for more details)
  * Accepted (Partner accepted the request, user is writing the post)
  * Submitted (post has been submitted to partner)
  * Published (backlink is online)

* `User_id`: User who created the request
* `Created_at`: datetime of creation of this request
* `Updated_at`: datetime of Last updated of the status
* `Updated_by`: User who updated the status

### Backlinks::Link

````
partner_id
business_id
request_id
url
term
link
status
activated_at
deactivated_at

````
* `partner_id`
* `business_id`
* `request_id` if applicable
* `url` URL of the page where the backlink is visible
* `term` Term of the link
* `link` URL of the link to our business
* `status`
  * active
  * inactive
* `activated_at` date of activation
* `deactivated_at` date of deactivation (after being activated)
