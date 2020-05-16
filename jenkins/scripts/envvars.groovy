import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*

instance = Jenkins.getInstance()
globalNodeProperties = instance.getGlobalNodeProperties()
envVarsNodePropertyList = globalNodeProperties.getAll(hudson.slaves.EnvironmentVariablesNodeProperty.class)

newEnvVarsNodeProperty = null
envVars = null

def env = System.getenv()

if ( envVarsNodePropertyList == null || envVarsNodePropertyList.size() == 0 ) {
  newEnvVarsNodeProperty = new hudson.slaves.EnvironmentVariablesNodeProperty();
  globalNodeProperties.add(newEnvVarsNodeProperty)
  envVars = newEnvVarsNodeProperty.getEnvVars()
} else {
  envVars = envVarsNodePropertyList.get(0).getEnvVars()
}

def env_var_map = [
  'BUILD_UID': env.BUILD_UID,
  'BUILD_GID': env.BUILD_GID,
  'DOCKER_REGISTRY': env.DOCKER_REGISTRY,
  'DOCKER_ORG': env.DOCKER_ORG,
  'AWS_ECR_CREDENTIALS': env.AWS_ECR_CREDENTIALS,
  'AWS_DEFAULT_REGION': env.AWS_DEFAULT_REGION,
  'AWS_S3_BUCKET': env.AWS_S3_BUCKET,
]

for (e in env_var_map) {
  envVars.put("${e.key}", "${e.value}")
  println("Adding: ${e.key} => ${e.value}")
}

instance.save()
