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

if __name__ == "__main__":
    diff = get_diff()
    review = review_code(diff)
    print(review)
