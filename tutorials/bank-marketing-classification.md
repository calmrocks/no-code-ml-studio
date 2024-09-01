# No-Code Machine Learning with AWS: Bank Marketing Example

This tutorial will guide you through creating a no-code machine learning model using AWS services, specifically focusing on the Bank Marketing dataset. The process includes data preparation, model training, deployment, and monitoring.

## Step-by-Step Workflow

### Step 1: Data Preparation

**Tool**: Amazon SageMaker Data Wrangler

**Process**:

1. **Download the Dataset**: Start by downloading the "Bank Marketing" dataset from the UCI repository.

   ```bash
   cd /path/to/your/repository/sandbox
   curl -O https://archive.ics.uci.edu/ml/machine-learning-databases/00222/bank.zip
   unzip bank.zip
   ```

2. **Upload to Amazon S3**: Upload the dataset to an S3 bucket so it can be accessed by SageMaker.

   ```bash
   aws s3 cp bank-full.csv s3://$BUCKET_NAME/
   ```

3. **Import Data into Data Wrangler**: In SageMaker Data Wrangler, import the dataset from S3.

    - Open Amazon SageMaker Studio.
    - Navigate to **Data Wrangler**.
    - Choose **Import Data** from Amazon S3 and select your uploaded dataset.
    - Change Delimiter from the default ',' to ';'.

4. **Data Cleaning and Feature Engineering**: Use the visual interface to handle missing values, convert categorical variables into numerical ones (e.g., one-hot encoding), and create any additional features that might improve model performance.

    - **Handle Missing Values**: Use Data Wrangler's built-in tools to fill or remove missing data.
    - **One-Hot Encoding**: Convert categorical features such as `job` and `education` into numerical features.
    - **Feature Engineering**: Create new features that might improve model accuracy.

5. **Save the Cleaned Data**: Once the data is prepared, you can save it back to S3 for model training.

    - Choose **Export** and save the cleaned dataset to your S3 bucket.

### Step 2: Model Training

**Tool**: Amazon SageMaker Autopilot

**Process**:

1. **Select the Data Source**: In SageMaker Autopilot, select the cleaned dataset from S3.

    - Open Amazon SageMaker Studio.
    - Navigate to **AotuML**.
    - Select **Create Experiment** and choose the cleaned dataset from your S3 bucket.
    - Put a experiment name

2. **Set Target Variable**: Set the target variable as `y` (the column indicating whether the customer subscribed to a term deposit).

    - In the Autopilot experiment setup, select `y` as the target variable.
    - In the train method and algorithms, choose Auto.
    - Use default deployment settings.
    - Create Experiment.

3. **Run Autopilot**: Initiate the training process. Autopilot will explore different models and preprocessing techniques automatically. If using Canvas, simply select the target variable and click "Predict."

    - Autopilot will automatically try various algorithms and preprocessing steps, optimizing for the best model.

4. **Review Model Performance**: Examine the different models trained by Autopilot, comparing performance metrics like accuracy, F1-score, precision, and recall.

    - Autopilot will generate several models, ranked by their performance.
    - Review metrics in the Autopilot console to select the best model.
    - Deploy the model (see instructions in the next section)

### Step 3: Model Deployment

**Tool**: Amazon SageMaker

**Process**:

1. **Deploy the Best Model**: Choose the best-performing model and deploy it as an endpoint from the SageMaker console.

    - In SageMaker Studio, navigate to the **Best Candidate** and select **Deploy Model**.
    - Follow the prompts to deploy the model as a real-time endpoint.

2. **Real-Time Predictions**: The deployed model can now be used to make real-time predictions on whether new customers are likely to subscribe to a term deposit.

    - Use the endpoint to integrate real-time predictions into your application or system.
    - Test the inference. 

### Step 4: Monitoring

**Tool**: Amazon SageMaker Model Monitor

**Process**:

1. **Set Up Monitoring**: Configure Model Monitor to track the data being sent to the model and its predictions, checking for data drift or performance degradation over time.

    - In SageMaker, navigate to **Governance**, and **Model dashboard**.
    - Choose the model, like **Name-best-model**.
    - Set up a monitoring schedule to regularly evaluate the model's performance.

2. **Retraining if Necessary**: If the model's performance starts to drop, you can use the monitored data to retrain the model using SageMaker Autopilot, repeating the steps above.

    - Use the drift detection reports to determine when retraining is necessary.
    - Retrain the model using the same or updated dataset in SageMaker Autopilot.

## Conclusion

This tutorial walked you through creating a machine learning model without writing any code, using AWS services like SageMaker Data Wrangler, Autopilot, Canvas, and Model Monitor. By following these steps, you can deploy an ML model capable of predicting customer behavior and monitor its performance over time.
