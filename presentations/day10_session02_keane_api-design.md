On our API design

APIs inform the way computers talk to other computers. Humans design them, revise them, and implement them, so they are also often very human-readable. They are used to automate tasks that require information transfer. A good example you might feel familiar with is a credit card transaction.

Your bank knows how much money you can spend. You know how much money you'd like to spend on a coffee. The coffee shop wants to take your money in exchange for coffee.

The coffee shop collects some details from you using your card (you can think of your card as a tool that comes pre-loaded with information about your ability to pay, and also the special passwords that allow that information to be used-- without your security code or expiration date, your card is not useful).

The coffee shop takes those details using software (and hardware!) for card processing. The card processor sends a request with your information (now encrypted!) to the card network. The card network takes that information and asks your bank to confirm that everything looks right-- that you have enough money, that's really your billing zip code, this is the kind of purchase you would actually want to make -- and your bank approves the authorization. Once there's an authorization, the coffee shop can send another request, this time asking for real money. They often do this at the end of the day in what's known as a 'batch job', or a big group of API calls done at once.

The authorization comes back through the card network, to the card processor, and the machine makes a little ding sound and tells you the transaction is approved. The barista gives you the coffee and the receipt, which is like a success record of the whole transaction pipeline, and you go on your way.

The APIs used in this process are more noun-oriented-- in the point-of-sale system, you're order is probably called "ORDER" and it has a couple different fields like "ITEMS" and "PAYMENT METHOD" and "PAYMENT STATUS". Depending on the place, you might have a rewards account that gets you points, so your order necessarily also has a field like "CUSTOMER" that helps the business keep track of what you buy and how much you spend.

Your payment method has nouns like "CARD NUMBER" and "EXP DATE". These are used to complete actions, but they aren't actions themselves. For that reason, you might see the API call look something like this: 

`card_processor_company_name/transactions/authorize/card_id`

And the parameters might be something like the amount, details about the purchase, etc. This is all about the exchange of money and goods and services.

I work with transactional APIs all the time, and knowing what I know about them, I wanted to make choices for my edition that would not be focused on transaction.

For one thing, we were focused on read-only: a model for an app where people co-edit materials using your interface might *benefit* from a transactional model.

For those reasons, we chose a verb-first approach. I care about what a user can do, and I want to be able to pass a parameter to that verb which will inform what it does. We have a lot more nouns than verbs (normal!) and we either want to do something to all of them or just one of them.

Here are three questions that might help you when considering your own API design?
- What is the smallest possible unit of 'thing I care about'?
- Which actions take similar inputs?
- What is my user's ideal path through the information?


