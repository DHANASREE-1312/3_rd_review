$workflowPath = ".github\workflows\security-scan.yml"
$content = Get-Content -Path $workflowPath -Raw

# Define the new server management section
$newServerSection = @'
      - name: Start Backend Server
        run: |
          cd backend
          nohup npm start > server.log 2>&1 &
          echo $! > server_pid.txt
          echo "Backend server starting..."
          sleep 15

      - name: Wait for Server to be Ready
        run: |
          echo "Waiting for server to be ready..."
          for i in {1..10}; do
            if curl -f http://localhost:5000/health || curl -f http://localhost:5000; then
              echo "Server is ready!"
              exit 0
            fi
            echo "Waiting for server to start... Attempt $i/10"
            sleep 10
          done
          echo "Server failed to start"
          echo "--- Server logs ---"
          cat backend/server.log || echo "No server logs available"
          exit 1

      - name: OWASP ZAP Baseline Scan
        uses: zaproxy/action-baseline@v0.12.0
        with:
          target: 'http://localhost:5000'
          cmd_options: '-a -j -l WARN -r report.html'
          allow_issue_writing: false
          fail_action: false

      - name: Stop Backend Server
        if: always()
        run: |
          echo "Stopping backend server..."
          if [ -f "backend/server_pid.txt" ]; then
            kill $(cat backend/server_pid.txt) || true
            rm -f backend/server_pid.txt
          fi
          pkill -f "node.*start" || true
          echo "Server stopped"
'@

# Replace the server management section in the workflow
$pattern = '(?s)(\s+- name: Start Backend Server.*?)(?=\n\s+- name: (?!Start Backend Server))'
$newContent = [regex]::Replace($content, $pattern, $newServerSection)

# Save the updated content
$newContent | Set-Content -Path $workflowPath -NoNewline

Write-Host "Workflow file has been updated successfully!"
