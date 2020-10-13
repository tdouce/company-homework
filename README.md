# Lovevery Take Home Project

This is the take-home project for engineers at Lovevery, and thanks in advance for taking the time on this.  The
goal of this project is to try to simulate some real-world work you'll do as an engineer for us, so that we can
see you write some code from the comfort of your own computer.

## The Project

This application is a *very* basic simulation of browsing our products and purchasing one of them.  The
application should work and it has tests to demonstrate that.  Much is simplified to keep the code minimal and
avoid making you deal with unnecessary complexity.

The basic flow is:

1. Visit `/` and see the products
1. Select a product to view it
1. Click to purchase that product
1. Fill in the data needed to purchase it:
   - Your name
   - Your child's name and birthdate
   - Your address and zip code
   - Your credit card information
1. This will create an order in our system, as well as a record for your child if they are not already in the database.

What we'd like you to do is allow this app to support gifting.  Instead of a parent buying one of our products for
their child, we want you to *also* allow anyone to buy a product for any child. Imagine you are someone's aunt or
uncle and you want to get them a Lovevery product as a gift.

There are three basic requirements:

* The gift giver can provide an optional message to the child.
* The gift giver must know the child's name and birthdate, as well as the child's parent's name, but does not need
to provide the child's shipping address or zipcode.
* The child must already be in the system, and we can use their previous order shipping information to know how to
ship the gift order.

Beyond that, it's up to you how to implement this and how it should look.

* There is no "one true answer" so write the code as you would normally for a job.
* Don't get fancy—this doesn't have to be a demonstration of every skill you have. Focus on solving the problem above as expediently as you can.  In the real world, that's what you'd do in order to get feedback and iterate.
* Make sure that a) your changes are well tested and b) you don't cause any of the existing tests to fail

Feel free to ask any questions of us, but you can simply make any assumptions you need to get moving. If you ask
us specifics about the requirements, we might say to use your best judgement.

## Getting Set Up

Assuming you have Ruby installed and are using a Ruby version manager like rvm or rbenv, you should be able to:

```
> bin/setup
> bin/rspec
```

This should install needed gems, set up your databases, and then run the tests, which should all pass.  If
anything is wrong at this stage and you can't obviously fix it, let us know.  This is *not* a test of your ability
to setup a Rails dev environment.

## Notes About The Code

We've kept this as free of third party dependencies as possible to keep things simple.  There are two main
dependencies this app uses that aren't part of Rails: Bootstrap and RSpec.

[Bootstrap](https://getbootstrap.com/) is used for styling the site so you don't have to write a bunch of CSS but
can still produce a decent-looking UI.  Hopefully you find it easy enough to use.

[RSpec](https://rspec.info) is a commonly used testing framework that we use, so we thought it was important to
put it into this project.  This is not a test of your ability to use every feature of RSpec, so if you are
unfamiliar with how it works, this is the very very basics that you need:

* `Rspec.describe`, `describe`, `RSpec.feature` create blocks of code and are for organization only.  They have no
other purpose
* `it` and `scenario` create blocks of code that *are* the test cases.  Each test case should be given to an `it`
or `scenario` block, and this app has many examples to follow.
* To assert things in your tests, you would write `expect(«thing to assert»).to eq(«value you expect it to be»)`, for example `expect(4 + 4).to eq(8)`.  RSpec has *many* (many) more ways to assert things, but if all you use is this one mechanism, you are fine.

Finally, while we tried to write a clean and well-tested app for you, we will go ahead and admit now that it's not
perfect and there are things that could be improved.  We might ask you about your thoughts on some of this code
later, but this is all part of the scenario - real-world code is never as nice as we'd like.

## What I Did And Why

The gifting feature code changes were intended to be as minimal as possible, while providing a well architected and 
tested implementation. The implementation is intended to deliver the most basic gifting functionality where improvements 
(i.e. ui/ux, error messaging, etc) could be delivered in subsequent iterations. Additionally, assumptions were made to 
simplify and expedite the delivery of this feature. 

The following assumptions were made:

* The gift giver can not provide a shipping address and zip code. It was not clear to me from the instructions if the 
  gifter should have the option to supply shipping information (i.e. form inputs present but not required).
* The shipping address and zip code for the previous order is correct.
* All children in the system have an existing order.

The user experience for purchasing an order as a gift is such that a user can indicate that an order is a gift on the 
product show page by checking a “Is this a gift?” option. The checkout form for a standard order (i.e. an order that is 
not a gift) is visually different from the form for a gift order (i.e. an order that is a gift). The gift order form 
attempts to clarify to the user which fields are required to match a previous order in the system, as well as describing 
where the gift will be shipped. If the user enters incorrect information (i.e. child’s name that is not associated with
a previous order), then the user sees a basic error message. It’s worth noting that I foresee the UI/UX experience for 
gift ordering as an opportunity for improvement.

The code base required changes to support gifting. The product show page (`app/view/products/show.html.erb`) was modified 
to support passing a gift parameter. The order form (`app/views/order/new.html.erb`) was modified to conditionally render 
the gift vs standard order version of the form. The `OrderForm` class was created to manage order processing. This class 
delegates gift order processing to the `GiftOrder` class and standard orders to the `StandardOrder` class. These classes 
were introduced, in part, to tease apart two different responsibilities (i.e. ordering a product as a gift vs ordering a 
product not as a gift). Additionally, it made the classes more narrowly focused (i.e. single responsibility) as well as 
making them easier to test. The column `orders.message` was added to the database to persist gift messages.

It’s worth noting that future iterations of the user experience could include:

* Providing real-time feedback to the user if the user enters incorrect information
* Populating form fields with previously submitted values on an unsuccessful form submission
* Add a more detailed error message when user enters incorrect information for a gift order