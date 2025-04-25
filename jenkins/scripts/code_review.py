import openai
import os
import sys

# Set up OpenAI API key
openai.api_key = os.getenv("OPENAI_API_KEY")
print('All environment variables:', os.environ)

print('==============', os.getenv("OPENAI_API_KEY"))

def get_diff():
    """Reads the code diff from stdin."""
    return sys.stdin.read()

def review_code(diff_text):
    """Sends the code diff to OpenAI and gets a review."""
    prompt = f"""You're a senior developer. Please review the following code diff and suggest improvements, highlight any potential bugs or performance issues. Be concise.

{diff_text}
"""

    try:
        # Use GPT-3.5 (fallback to GPT-3.5 if GPT-4 is unavailable)
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",  # Fallback to GPT-3.5
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
        # Get the diff from stdin
        diff = get_diff()
        if not diff.strip():
            print("No code changes to review.")
            exit(0)

        # Perform the review
        review = review_code(diff)
        print(review)
    except Exception as e:
        print(f"AI review failed: {e}")
        exit(1)
