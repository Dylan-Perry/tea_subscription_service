# Tea Subscription Service

This Tea Subscription Service exposes several API endpoints for managing tea subscriptions for customers.

## Database Structure

Currently, the database is comprised of four tables:
1. Customers, which have many subscriptions
2. Teas, which have many subscriptions
3. Subscriptions, which have many teas
4. Tea Subscriptions, which is a joins table between Teas and Subscriptions

## Exposed Endpoints

Currently, the following endpoints are functional and tested:
- Create Customer Subscription: `POST /api/v1/customers/:customer_id/subscriptions`
- Cancel Customer Subscription: `PATCH /api/v1/customers/:customer_id/subscriptions/:subscription_id`
- View all Customer Subscriptions: `GET /api/v1/customers/:customer_id/subscriptions`

