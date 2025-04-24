import openai
import os
import subprocess

openai.api_key = os.getenv("OPENAI_API_KEY")

# Lấy các file đã thay đổi
diff_files = subprocess.getoutput("git diff --name-only origin/main HEAD").splitlines()

files_to_review = []
for file in diff_files:
    if not file.endswith(('.js', '.ts', '.vue', '.py', '.java', '.tsx')):
        continue
    code = subprocess.getoutput(f"git diff origin/main HEAD -- {file}")
    if code:
        files_to_review.append(f"### {file}\n{code[:1500]}")

if not files_to_review:
    print("No code changes to review.")
    exit(0)

prompt = f"""
You are an AI code reviewer like GitHub Copilot. Please review the following code changes and provide suggestions or improvements.

{chr(10).join(files_to_review)}
"""

response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": "You are a senior code reviewer AI like GitHub Copilot."},
        {"role": "user", "content": prompt}
    ]
)

review_output = response.choices[0].message.content.strip()

with open("jenkins/scripts/copilot_output.txt", "w", encoding="utf-8") as f:
    f.write(review_output)

print("Copilot review complete.")
