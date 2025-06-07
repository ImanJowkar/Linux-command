#!/bin/bash

# Define file checks: path:owner:group:permission
CHECKS=(
  "/etc/grub.cfg:root:root:600"
  "/etc/motd:root:root:600"
  "/etc/issue:root:root:644"
  "/etc/issue.net:root:root:644"
  "/boot/grub/*:root:root:600"
  "/boot/efi/EFI/*:root:root:600"
  "/etc/crontab:root:root:600"
  "/etc/cron.hourly/*:root:root:700"

)


# Output HTML header
cat <<EOF > report.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>File Permissions Report</title>
<style>
  body { font-family: Arial, sans-serif; padding: 20px; }
  table { border-collapse: collapse; width: 100%; }
  th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
  th { background-color: #f2f2f2; }
  .pass { color: green; font-weight: bold; }
  .fail { color: red; font-weight: bold; }
</style>
</head>
<body>
<h2>File Permissions and Ownership Report</h2>
<table>
<tr><th>File</th><th>Mode</th><th>Owner:Group</th><th>Status</th></tr>
EOF

for check in "${CHECKS[@]}"; do
  IFS=":" read -r PATH_PATTERN EXPECTED_OWNER EXPECTED_GROUP EXPECTED_PERM <<< "$check"

  MATCHED=0

  for FILE in $PATH_PATTERN; do
    if [ ! -e "$FILE" ]; then
      continue
    fi

    MATCHED=1
    PERM=$(stat -c "%a" "$FILE")
    OWNER=$(stat -c "%U" "$FILE")
    GROUP=$(stat -c "%G" "$FILE")

    STATUS="PASS"
    CLASS="pass"
    [[ "$OWNER" != "$EXPECTED_OWNER" ]] && STATUS="FAIL" && CLASS="fail"
    [[ "$GROUP" != "$EXPECTED_GROUP" ]] && STATUS="FAIL" && CLASS="fail"
    [[ "$PERM" != "$EXPECTED_PERM" ]] && STATUS="FAIL" && CLASS="fail"

    printf "<tr><td>%s</td><td>%s</td><td>%s:%s</td><td class=\"%s\">%s</td></tr>\n" \
      "$FILE" "$PERM" "$OWNER" "$GROUP" "$CLASS" "$STATUS" >> report.html
  done

  if [ $MATCHED -eq 0 ]; then
    printf "<tr><td>%s</td><td>-</td><td>-</td><td class=\"fail\">FAIL (not found)</td></tr>\n" "$PATH_PATTERN" >> report.html
  fi
done

# Close HTML
cat <<EOF >> report.html
</table>
</body>
</html>
EOF

echo "Report saved to report.html"
