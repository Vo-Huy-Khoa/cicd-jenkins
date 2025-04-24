# jenkins/scripts/code_review.py
import openai
import os
import sys

openai.api_key = os.getenv("OPENAI_API_KEY")

def get_diff():
    return sys.stdin.read()

def review_code(diff_text):
    prompt = f"""You're a senior developer. Please review the following code diff and suggest improvements, highlight any potential bugs or performance issues. Be concise.

{diff_text}
"""

    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are an expert code reviewer."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.2,
            max_tokens=500
        )
        return response.choices[0].message.content
    except Exception as e:
        print(f"Error during AI review: {e}")
        exit(1)

if __name__ == "__main__":
    try:
        diff = get_diff()
        if not diff.strip():
            print("No code changes to review.")
            exit(0)

        review = review_code(diff)
        print(review)
    except Exception as e:
        print(f"AI review failed: {e}")
        exit(1)
