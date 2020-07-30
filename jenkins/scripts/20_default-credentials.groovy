
import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.jenkins.plugins.awscredentials.*
import com.cloudbees.hudson.plugins.modeling.*


import hudson.plugins.sshslaves.*;

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

def env = System.getenv()

usernameAndPassword = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL, "GIT_USER", "Git Credentials", env.GIT_USER, env.GIT_PASS
)

usernameAndPassword2 = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL, "AWS_ACCESS_KEY_ID", "AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY", env.AWS_ACCESS_KEY_ID, env.AWS_SECRET_ACCESS_KEY
)

store.addCredentials(domain, usernameAndPassword)
store.addCredentials(domain, usernameAndPassword2)

awsCredentials = new AWSCredentialsImpl(
	CredentialsScope.GLOBAL, "AWS_CREDENTIALS_ID", env.AWS_ACCESS_KEY_ID, env.AWS_SECRET_ACCESS_KEY, "AWS Credentials"
)

store.addCredentials(domain, awsCredentials)

