# README

<strong>The Task:</strong>
<p>As a marketplace for luxury goods we want to be able to price items automatically. 
For simplicity purposes you can assume that the only item type being sold through Worthy is a diamond. Diamonds can be categorized by their Carat Weight, Cut, Color and Clarity.
The calculation should be done based on the company’s past deals. Please add a new feature to enable this.</p> 

<strong>General Instructions:</strong> 
<ul>
  <li>The code should be done in ROR / NodeJS with any framework.</li>
  <li>You can make common assumptions if needed, just mention them in your submission.</li>
</ul>

<strong>Advantages:</strong> 
<ul>
  <li>Create a client side representation of the calculator</li>
  <li>Imagination and creativity - surprise us!</li>
</ul>

<strong>Explanations, references and assumptions</strong>

Used technologies:

Due to time constraints, I used the technologies I worked with earlier
<ul>
  <li>Backend - Rails5</li>
  <li>Frontend - Jquery, Bootstrap</li>
</ul>

I used MySQLite to store data because it easy to implement (default DB in Rails) and enough for my purposes. Dataset was scraped from worthy.com (lib/data_scraper.rb). 

I assumed the variables (shape, color, clarity and carat weight) are independent and price is continuous variable. 
Сonsidering all of the above I used multivariate regression to predict price based on recent deals dataset. I decided to use  <a href="https://github.com/ankane/eps">Eps ruby gem</a> because it simple and not required prior knowledge of machine learning.
















  
  
