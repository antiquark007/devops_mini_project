#!/bin/bash

# Install Jenkins Plugins Script
# This script installs all required plugins for Pipeline CI/CD

JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_PASS="admin"

echo "🔧 Installing Jenkins Plugins..."
echo "================================"

# Required plugins
PLUGINS=(
    "pipeline-model-declarative:latest"
    "pipeline-stage-view:latest"
    "git:latest"
    "github:latest"
    "github-api:latest"
    "docker-commons:latest"
    "docker-pipeline:latest"
    "github-branch-source:latest"
    "credentials:latest"
    "credentials-binding:latest"
    "ssh-agent:latest"
)

# Get Jenkins CLI JAR
echo "📥 Downloading Jenkins CLI..."
curl -s -o jenkins-cli.jar "${JENKINS_URL}/jnlpJars/jenkins-cli.jar"

if [ ! -f jenkins-cli.jar ]; then
    echo "❌ Failed to download Jenkins CLI"
    exit 1
fi

echo "✅ Jenkins CLI downloaded"
echo ""

# Install each plugin
for plugin in "${PLUGINS[@]}"; do
    echo "📦 Installing: $plugin"
    java -jar jenkins-cli.jar \
        -s "$JENKINS_URL" \
        -auth "$JENKINS_USER:$JENKINS_PASS" \
        install-plugin "$plugin" \
        2>&1 | grep -E "Installing|already|ERROR|Success" || echo "  → Queued for installation"
done

echo ""
echo "⏳ Restarting Jenkins (waiting 5 seconds)..."
sleep 5

# Restart Jenkins
java -jar jenkins-cli.jar \
    -s "$JENKINS_URL" \
    -auth "$JENKINS_USER:$JENKINS_PASS" \
    restart

echo "✅ Jenkins restart initiated"
echo ""
echo "⏳ Waiting for Jenkins to restart (30 seconds)..."
sleep 30

# Check if Jenkins is back
for i in {1..30}; do
    if curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL" | grep -q "200\|403"; then
        echo "✅ Jenkins is back online!"
        break
    fi
    echo "  Attempt $i/30..."
    sleep 2
done

# Cleanup
rm -f jenkins-cli.jar

echo ""
echo "🎉 Plugin installation complete!"
echo ""
echo "Next steps:"
echo "1. Access Jenkins: $JENKINS_URL"
echo "2. Create a new Pipeline job"
echo "3. Configure with your GitHub repo"
echo "4. Set up GitHub webhook"
