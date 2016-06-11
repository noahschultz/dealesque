# Milestone 0.2

## Find the best offer

Using picked items, search the offers for each item and find the least expensive combination
Use used item offers by default
Try to find the most common used offer merchant to reduce postage costs
If available, use the postage information too

## Put items in Amazon cart

Put items with the computed offer / price / merchant
Use OfferListingId for selected offer, instead of item ASIN / ID

## Browse Amazon items

Show Amazon list price
Show smallest used price, if available

## Picked items

### When not computed

Show Amazon list price
Show Amazon real price, strike-through the list price in that case
Show smallest used price, if available
Show smallest new price, if available

### When computed

Show computed price per item
Show merchant
Group items by merchant (colorize)

# TODO

* find all the offers by scraping item detail pages
  get all the data on search
  if considerably slowing things, do it on pick item or when calculating best offer
  TODO make sure no duplicate offers are created in the process
* use new condition offer in case a merchant has both used and new and the price is the same
* find shipping options and costs
  if nothing else, use web scraping
  take care to calculate correctly for amazon logged in and not logged in user
* find more items
  current limit is 10
* create a table of merchant offers / items combinations
  so the user can easily see which merchant offers which items

# Background scraping

Use sidekiq for offloading job to background
Pass just the item id and more offers url, to reduce memory footprint
Use Redis To Go on Heroku
Add sidekiq admin view to the mix, no protection yet

Use pjax, private_pub/faye to subscribe the browser to updates
Study rails/browser sockets so maybe there is no need for an entire server for pushing data to browser

Describe the transition from plain scraper to background job
And all the segments required for this to work, the architecture in short
Including observable thingy so events and data can pass from background job to the browser

Resources:
* Rails Casts: private-pub, sidekiq, pjax, entire background job section
* Ruby Tapas: http://www.rubytapas.com/episodes/21-Domain-Model-Events
* Schatula -> UI -> Messaging links
