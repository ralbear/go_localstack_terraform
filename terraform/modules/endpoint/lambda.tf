resource "aws_lambda_function" "this" {
    function_name    = var.function_name
    filename         = "../bin/${var.zip_name}"
    handler          = "main"
    source_code_hash = filebase64sha256("../bin/${var.zip_name}")
    role             = aws_iam_role.iam_for_lambda.arn
    runtime          = "go1.x"
    timeout          = 5
    memory_size      = 128
    publish          = true
}

resource "aws_cloudwatch_log_group" "this" {
    name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
    retention_in_days = 30
}
