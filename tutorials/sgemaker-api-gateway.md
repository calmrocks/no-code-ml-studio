# Expose a SageMaker Endpoint via API Gateway

This tutorial will guide you through deploying a CloudFormation stack to expose a SageMaker endpoint via API Gateway. By the end of this tutorial, you'll have a RESTful API that external clients can use to interact with your SageMaker model.

## Prerequisites

Before you begin, ensure you have the following:
- An existing SageMaker endpoint.
- AWS CLI installed and configured.
- Permissions to create resources in AWS such as API Gateway, IAM roles, and SageMaker.

## Step 1: Deploy the CloudFormation Stack

We have provided a CloudFormation template named `sagemaker-api-gateway.yml` under the `cloudformation` folder. This template creates all the necessary resources, including API Gateway, IAM roles, and the integration with the SageMaker endpoint.

To deploy the CloudFormation stack, run the following command:

```bash
aws cloudformation create-stack \
--stack-name SageMakerApiGatewayStack \
--template-body file://cloudformation/sagemaker-api-gateway.yml \
--parameters ParameterKey=SageMakerEndpointName,ParameterValue=<YourEndpointName> \
--capabilities CAPABILITY_IAM
```

Replace `<YourEndpointName>` with the name of your SageMaker endpoint.

### Step 2: Retrieve the API Gateway URL and API Key

Once the stack is successfully created, retrieve the API Gateway URL and the API Key ARN using the following command:

```bash
aws cloudformation describe-stacks --stack-name SageMakerApiGatewayStack --query "Stacks[0].Outputs"
```

The output will include:
- **ApiGatewayUrl**: The URL of the deployed API Gateway.
- **ApiGatewayApiKeyArn**: The ARN of the API Key created for this API.

## Step 3: Test the API Gateway

With the API Gateway URL and API Key in hand, you can test the API using `curl` or any other HTTP client.

```bash
curl -X POST \
https://<API-ID>.execute-api.<Region>.amazonaws.com/prod/invoke \
-H "Content-Type: application/json" \
-H "x-api-key: <Your-Api-Key>" \
-d '{"features": [[35, "management", "married", "tertiary", "no", 1200, "yes", "no", "cellular", 15, "jun", 120, 3, -1, 0, "unknown"]]}'
```

Replace `<API-ID>`, `<Region>`, and `<Your-Api-Key>` with the values you retrieved in the previous step.

## Step 4: Secure the API

While the API Key provides basic security, consider implementing additional measures to secure your API further:
- **IAM Authorization**: Restrict access using IAM roles and policies.
- **Custom Authorizers**: Implement Lambda functions or Amazon Cognito for custom authentication mechanisms.
- **AWS WAF**: Deploy AWS Web Application Firewall (WAF) to protect your API from common web exploits.

## Conclusion

By following this tutorial, you have successfully exposed a SageMaker endpoint via API Gateway using a CloudFormation template. This setup allows external clients to interact with your machine learning model through a secure and scalable RESTful API.
