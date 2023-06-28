---
marp: true
size: 16:9
paginate: true
_paginate: false
title: Text analysis II
_class: invert
style: |
  section {
    background-color: #00000;
  }
footer: SICSS Berlin - Day 5 - 2023/07/07
---

# Text analysis II
## Relational based methods  

---

# Introduction

- show seccond part of NLP overview
- more advanced methods -> context matters vs. bag of words

Our words are our raw data, and to feed them into models, we need to convert them into a format that our algorithms can understand: numbers. One of the most potent ways to achieve this is through word embeddings.

Word embeddings are the steppingstone for the current advancements in Natural Language Processing (NLP) like BERT and ChatGPT.

---

# Word2Vec

[Explanation](https://medium.com/@igniobydigitate/word-embeddings-helping-computers-understand-language-semantics-dd3456b1f700)

- word to vector [article 2013](...)
- Different steps:
  - context window (# words before and after focus word)
  - matrix of one hot encodings for focus and context words
  - train neural network: focus word -> hidden layer -> context words
  - weights on these edges are the word embeddings
  - set size of hidden layer: dimension of output vectors

CBOW (Continuous Bag of Words) and Skip-gram
  - CBOW predicts target word from context words
  - Skip-gram predicts context words given target word


---

# ChatGPT

1. Definition: Word embeddings are distributed representations of words in a vector space. They capture semantic and syntactic relationships between words, allowing machines to understand the meaning of words based on their contextual usage.

2. Motivation: Traditional approaches to natural language processing (NLP) relied on handcrafted features or sparse representations, which often failed to capture the complexity of language. Word embeddings emerged as a way to overcome these limitations and provide more nuanced representations of words.

3. Representation learning: Word embeddings are a form of representation learning, where a model learns to automatically extract useful features or representations from raw data. In the case of word embeddings, the model learns to represent words as dense vectors in a continuous vector space.

4. Distributional hypothesis: The foundation of word embeddings is the distributional hypothesis, which states that words that occur in similar contexts tend to have similar meanings. Word embeddings leverage this principle by learning representations that capture these contextual relationships.

5. Training process: Word embeddings are typically learned through unsupervised learning from large corpora of text data. Popular methods include Word2Vec, GloVe, and FastText. These models use different algorithms, such as neural networks or matrix factorization, to learn word representations.

6. Vector space properties: Word embeddings are designed to have useful properties in the vector space. Similar words are represented by vectors that are close together, while dissimilar words are represented by vectors that are far apart. This allows for various mathematical operations on word embeddings, such as vector arithmetic and clustering.

7. Applications: Word embeddings have revolutionized many NLP tasks. They are used in sentiment analysis, machine translation, text classification, named entity recognition, question answering, and more. Word embeddings provide a way to encode semantic information into machine learning models, enabling them to understand and generate human language.

8. Pretrained embeddings: Pretrained word embeddings are available for many languages and domains. These embeddings are trained on large corpora and can be directly used in downstream NLP tasks, saving the time and resources required for training from scratch.

9. Limitations: Word embeddings have some limitations. They may not capture certain rare or domain-specific words well. They can also inherit biases present in the training data. Additionally, word embeddings do not explicitly encode word sense disambiguation or compositional meaning, although some methods attempt to address these challenges.

10. Advances and future directions: Word embeddings continue to be an active area of research. Recent advancements include contextualized word embeddings (e.g., BERT, GPT) that capture word meaning based on the entire context, as well as specialized embeddings for subword units like characters and morphemes. The field is also exploring techniques for interpretability and fairness in word embeddings.

---

# Word Embeddings

- shortcomings from bag of words and simple DFM
- one-hot vectors or count based 

Distributional hypothesis
"you may know the meaning of a word by the company it keeps"


Using this underlying assumption, you can use Word2Vec to:

- Surface similar concepts
- Find unrelated concepts
- Compute similarity between two words and more!

neuronal network

Word2Vec - 2013
- neural network
- CBOW (predict word by context)
- Skip-gram (predict the context)

Glove - 2015
- hybrid: adds global co-occurance statistics to window-based-method)
- faster and also for rare words

FastText
- character n-grams (for morphologically rich languages like german, arabic)


"Word embeddings are sentiment agnostic and capture conceptual similarity but not necessarily sentiment similarity"

"it is a mathematical way of representing the meaning of words. Word embeddings represent words as vectors of real-valued numbers, where each dimension in the vector corresponds to a particular feature or aspect of the word’s meaning. In a way, word embeddings are like a dictionary for a computer. Just like we use a dictionary to look up the meanings of words, a computer can use a word embedding to look up the numerical vector representation of a word."

---

# Word Embeddings: Go on

- Search Engines: Word embeddings can improve the matches in a search engine. E.g., if you search for “soccer,” the search engine also gives you results for “football” as they’re two different names for the same game

- Language Translation: Word embeddings are crucial for language translation. Two or more words with the same meaning words in two different languages would have similar vectors, which would make it easier for a computer to translate from one language to another.

- Chatbots: We’ve seen increasing use of chatbots across different applications for different purposes. The users of a chatbot can write a query in any form and can use different words to convey the same thing.

Use cases:
- find biases in language: Embeddings also encode doctors and computer programmers as male professions and nurses and homemakers as female professions (Ethayarajh et al., 2019)
- cultural differences: 
- find similar words to build custom dictionary
- define working variables that embody the concept or research questions (Olivier Toubia, Jonah Berger, and Jehoshua Eliashberg.
1.    How quantifying the shape of stories predicts
their success. Proceedings of the National Academy
of Sciences, 118(26):e2011695118)
- Nikhil Garg, Londa Schiebinger, Dan Jurafsky, and
James Zou. 2018. Word embeddings quantify 100
years of gender and ethnic stereotypes. Proceedings
of the National Academy of Sciences, 115(16):E3635–
E3644.


online-Test ([Link](http://bionlp-www.utu.fi/wv_demo/))



Bag of Words (BOW) vs. Neural Networks (Embeddings)
count based methods vs. predictiv methods
frequency vs. meaning of terms