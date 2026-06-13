from fastapi import FastAPI
from dotenv import load_dotenv
import os
from model import CreateOrderRequest, TestRequest, VerifyPaymentRequest
import razorpay

load_dotenv()

app=FastAPI()


RAZORPAY_KEY_ID=os.getenv('RAZORPAY_KEY_ID')
RAZORPAY_SECRET=os.getenv('RAZORPAY_SECRET')

client=razorpay.Client(
    auth=(RAZORPAY_KEY_ID,RAZORPAY_SECRET)
)


@app.get("/")
def home():
    return{
        "message": "Backend running",
        "razorpay_configured": bool(
            RAZORPAY_KEY_ID and RAZORPAY_SECRET
        )
    }

@app.post("/create-order")
def create_order(request: CreateOrderRequest ):

    order= client.order.create({
        "amount": int(request.amount) *100,
        "currency": "INR"
    })

    return order


@app.post("/test")
def test_api(request: TestRequest):

    return {
        "mssg": request.mssg
    }




@app.post("/verify-payment")
def verify_payment(request: VerifyPaymentRequest):

    try:

        client.utility.verify_payment_signature(
            {
                "razorpay_order_id": request.razorpay_order_id,
                "razorpay_payment_id": request.razorpay_payment_id,
                "razorpay_signature": request.razorpay_signature
            }
        )

        return {
            "verified": True
        }
    
    except Exception as e:
        return {
            "verified": False,
            "error": str(e)
        }
    