#!/bin/bash

# Function to confirm the deletion of all SageMaker resources
confirm_deletion() {
    read -r -p "WARNING: This will delete ALL SageMaker resources in your account, including endpoints, models, training jobs, and more. This action cannot be undone. Are you sure you want to proceed? (yes/no): " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo "Proceeding with deletion..."
            ;;
        *)
            echo "Aborting deletion."
            exit 1
            ;;
    esac
}

# Run the confirmation function
confirm_deletion

# Delete all SageMaker endpoints
echo "Deleting SageMaker Endpoints..."
for endpoint in $(aws sagemaker list-endpoints --query "Endpoints[].EndpointName" --output text)
do
  echo "Deleting endpoint: $endpoint"
  aws sagemaker delete-endpoint --endpoint-name $endpoint
done

# Delete all SageMaker endpoint configurations
echo "Deleting SageMaker Endpoint Configurations..."
for endpoint_config in $(aws sagemaker list-endpoint-configs --query "EndpointConfigs[].EndpointConfigName" --output text)
do
  echo "Deleting endpoint configuration: $endpoint_config"
  aws sagemaker delete-endpoint-config --endpoint-config-name $endpoint_config
done

# Delete all SageMaker models
echo "Deleting SageMaker Models..."
for model in $(aws sagemaker list-models --query "Models[].ModelName" --output text)
do
  echo "Deleting model: $model"
  aws sagemaker delete-model --model-name $model
done

# Delete all SageMaker training jobs
echo "Deleting SageMaker Training Jobs..."
for training_job in $(aws sagemaker list-training-jobs --query "TrainingJobSummaries[].TrainingJobName" --output text)
do
  echo "Stopping training job: $training_job"
  aws sagemaker stop-training-job --training-job-name $training_job || echo "Skipping stopping job $training_job as it may already be completed or stopped."
done

# Delete all SageMaker hyperparameter tuning jobs
echo "Deleting SageMaker Hyperparameter Tuning Jobs..."
for tuning_job in $(aws sagemaker list-hyper-parameter-tuning-jobs --query "HyperParameterTuningJobSummaries[].HyperParameterTuningJobName" --output text)
do
  echo "Stopping tuning job: $tuning_job"
  aws sagemaker stop-hyper-parameter-tuning-job --hyper-parameter-tuning-job-name $tuning_job || echo "Skipping stopping tuning job $tuning_job as it may already be completed or stopped."
  aws sagemaker delete-hyper-parameter-tuning-job --hyper-parameter-tuning-job-name $tuning_job
done

# Delete all SageMaker processing jobs
echo "Deleting SageMaker Processing Jobs..."
for processing_job in $(aws sagemaker list-processing-jobs --query "ProcessingJobSummaries[].ProcessingJobName" --output text)
do
  echo "Stopping processing job: $processing_job"
  aws sagemaker stop-processing-job --processing-job-name $processing_job || echo "Skipping stopping processing job $processing_job as it may already be completed or stopped."
done

# Delete all SageMaker notebook instances
echo "Deleting SageMaker Notebook Instances..."
for notebook_instance in $(aws sagemaker list-notebook-instances --query "NotebookInstances[].NotebookInstanceName" --output text)
do
  echo "Stopping notebook instance: $notebook_instance"
  aws sagemaker stop-notebook-instance --notebook-instance-name $notebook_instance || echo "Skipping stopping notebook instance $notebook_instance as it may already be stopped."
  echo "Deleting notebook instance: $notebook_instance"
  aws sagemaker delete-notebook-instance --notebook-instance-name $notebook_instance
done

# Delete all SageMaker AutoML jobs
echo "Deleting SageMaker AutoML Jobs..."
for automl_job in $(aws sagemaker list-auto-ml-jobs --query "AutoMLJobSummaries[].AutoMLJobName" --output text)
do
  echo "Stopping AutoML job: $automl_job"
  aws sagemaker stop-auto-ml-job --auto-ml-job-name $automl_job || echo "Skipping stopping AutoML job $automl_job as it may already be completed or stopped."
done

# Delete all SageMaker endpoints created by AutoML jobs
echo "Deleting SageMaker Endpoints for AutoML Jobs..."
for automl_endpoint in $(aws sagemaker list-endpoints --query "Endpoints[?EndpointName.contains(@, 'auto-ml')].EndpointName" --output text)
do
  echo "Deleting AutoML endpoint: $automl_endpoint"
  aws sagemaker delete-endpoint --endpoint-name $automl_endpoint
done

echo "Cleanup complete."
