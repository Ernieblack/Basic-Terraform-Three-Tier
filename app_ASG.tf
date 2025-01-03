
# Launch Template


resource "aws_launch_template" "app_template" {
  name          = "app_template"
  instance_type = "t2.micro"
  image_id      = "ami-0c76bd4bd302b30ec"
  key_name      = aws_key_pair.webkp.key_name
  #user_data = base64encode(file("user_data.sh"))  # Include a user data script if applicable

  network_interfaces {
    security_groups             = [aws_security_group.app_sg.id]
    associate_public_ip_address = false
  }
}




resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 2
  min_size            = 1
  max_size            = 2
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.priv1.id, aws_subnet.priv2.id] # Public subnets for the web tier
  target_group_arns   = [aws_lb_target_group.lb-target-app.arn]


  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.app_template.id
      }

    }
  }
}

resource "aws_autoscaling_attachment" "lb-target-app" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn   = aws_lb_target_group.lb-target-app.arn
}



# Autoscaling Policies (Optional: For dynamic scaling)
resource "aws_autoscaling_policy" "scale_out_policy_app" {
  name                   = "scale-out-app"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_autoscaling_policy" "scale_in_policy_app" {
  name                   = "scale-in-app"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}



