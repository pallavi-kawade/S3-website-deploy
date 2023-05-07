package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformSSAwithCloudfrontandS3(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1::Set the path to the Terraform code that will be tested.
		TerraformDir: "../../serving_static_asset_with_cloudfront_and_s3",

		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"vars.tfvars"},

		// Backend Environment variables to set when running Terraform
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("bucket"),
			"key":    os.Getenv("key"),
			"region": os.Getenv("region"),
		},


	})

	// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2::Run "terraform init" and "terraform apply".
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	cloudfront_domain := terraform.Output(t, terraformOptions, "cloudfront_domain")
	bucket_name := terraform.Output(t, terraformOptions, "bucket_name")
	cf_arn := terraform.Output(t, terraformOptions, "cf_arn")
	Oai_id := terraform.Output(t, terraformOptions, "Oai_id")

	// Verify we're getting back the outputs we expect
	assert.Contains(t, cloudfront_domain, "cloudfront.net")
	assert.Contains(t, bucket_name, "")
	assert.Contains(t, cf_arn, "arn:aws:cloudfront")
	assert.Contains(t, Oai_id, "")


}
