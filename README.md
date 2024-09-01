# No-Code ML Studio

## Introduction

Welcome to No-Code ML Studio, a platform designed to help you deploy and use machine learning models on AWS without writing any code. This guide will walk you through the steps to set up the infrastructure, use API Gateway to expose your SageMaker endpoints, and work with various examples, including the Bank Marketing Classification example.

## Prerequisites

Before getting started, ensure you have the following:
- An AWS account with the necessary permissions to create resources such as SageMaker, API Gateway, IAM roles, and CloudFormation stacks.
- AWS CLI installed and configured with your credentials.
- Basic knowledge of AWS services and machine learning concepts.

## Create Infrastructure Stack

The first step is to create the necessary infrastructure using CloudFormation. This includes setting up an S3 bucket and other resources required for your machine learning workflows.

### Step 1: Create the Infrastructure Stack

1. Navigate to the `cloudformation` directory:

    ~~~bash
    cd cloudformation
    ~~~

2. Create the infrastructure stack using the provided CloudFormation template:

    ~~~bash
    aws cloudformation create-stack --stack-name NoCodeMLStack --template-body file://nocode-ml-setup.yaml --capabilities CAPABILITY_NAMED_IAM
    ~~~

3. Wait for the stack creation to complete:

    ~~~bash
    aws cloudformation wait stack-create-complete --stack-name NoCodeMLStack
    ~~~

4. Retrieve the S3 bucket name created by the stack:

    ~~~bash
    BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name NoCodeMLStack --query "Stacks[0].Outputs[?OutputKey=='S3BucketName'].OutputValue" --output text)
    echo $BUCKET_NAME
    ~~~

5. Switch to the `sandbox` directory to run the rest of the tutorials:

    ~~~bash
    cd ../sandbox
    ~~~

### Step 2: Cleanup Infrastructure Stack

After completing your work, it's important to clean up the resources to avoid unnecessary charges. Even if you encounter issues in the middle of the process, ensure that you delete the CloudFormation stack:

~~~bash
aws cloudformation delete-stack --stack-name NoCodeMLStack
~~~

## Using API Gateway for SageMaker Endpoint

To expose your SageMaker model endpoint via a public API, you can use Amazon API Gateway. This allows external clients to interact with your machine learning models through a RESTful API.

Follow the steps in the [API Gateway Tutorial](tutorials/sagemaker-api-gateway.md) to deploy a CloudFormation stack that integrates API Gateway with your SageMaker endpoint. This tutorial provides detailed instructions on setting up the API Gateway, creating necessary IAM roles, and configuring the integration with SageMaker.

## Examples

### Bank Marketing Classification Example

The Bank Marketing Classification example demonstrates how to train, deploy, and test a machine learning model using AWS SageMaker with No-Code ML Studio. This example uses the Bank Marketing dataset to build a classification model that predicts whether a customer will subscribe to a term deposit.

For step-by-step instructions on running this example, please refer to the [Bank Marketing Classification Tutorial](tutorials/bank-marketing-classification.md).

## Conclusion

This guide provides a starting point for deploying and using machine learning models on AWS with No-Code ML Studio. Refer to the individual tutorials for more detailed steps and explore additional examples as they become available.

Feel free to contribute by adding new examples or improving existing tutorials!