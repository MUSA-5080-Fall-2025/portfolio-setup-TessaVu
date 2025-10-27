# MUSA5080-Assignment3

Welcome to our group's repo for the assignment3/midterm.

## [EMBEDDING PLOTS BETWEEN TWO DIFFERENT QMD FILES](https://quarto.org/docs/authoring/notebook-embed.html)

## IMPORTANT NOTE FROM TESS:

I've started on the data cleaning for the primary dataset we're supposed to use,
but GitHub doesn't allow files over 100 MB, so I zipped the property dataset.

You'll need to unzip it and rename the opa_properties_public.csv to philly_properties.csv
in order to use it.

Unfortunately, if you try to commit the unzipped dataset, it'll bar you from committing in the future.
So make sure to exclude committing the .csv file by unchecking it on GitHub Desktop before you commit.

[Property Data Link](https://opendata-downloads.s3.amazonaws.com/opa_properties_public.csv)

# Model Design Ideas

NOTE: These are all suggestions and notes to get started, we can pick and choose from here or if anyone has different ideas!

Practically optimize for:

- Interpretation

- Stability

- Economic Consistency

- Spatial Patterns

## Model Structure

What needs to be log-transformed, polynomial, categorical, or raw?

### Response

- Sale Price

### Predictors Suggestions

- Square Feet

  - Log-transformed; size has diminishing returns; stabilizes variance.
  
- Bathrooms

  - Raw; low multicollinearity with square feet because the relative proportion is marginal.
  
- Parking

  - Raw; parking spot premium; no interaction with square feet.
  
- Building Age

  - Polynomial term; U-shape (parabolic), because of "vintage" premium; we have to center age before squaring it!
  
- Air Conditioning (AC)

  - Boolean; yes or no.
  
- Unit Type

  - Categorical; detached, attached, condo, townhouse, etc.; could be a good candidate for fixed effect (FE).
  
- Neighborhood

  - Categorical; different neighborhoods could be a good candidate for FE too.
  
- Market Time

  - Could be a fixed categorical effect if we wanna try, like doing 2023 Q1-4 and 2024 Q1-4 to reflect real estate market fluctuations.
  
  - We have more granular dates so I thought I'd suggest this.
  
**NOTE:** I think we should avoid bedroom number like the plague because it's very multicollinear with square feet.

### Spatial Features (Feature Engineering) as Predictors Suggestions

- Downtown Proximity

  - Could compute network distances, not Euclidean, I think it would be a more honest measurement.

- Transit Proximity

  - Same with network distance.

- Walkability Score or Index

- Park Proximity

  - Could be good, but would have multicollinearity if we use other proximity measures.

- Park Size

  - I think this could be a good idea, because we're already aggregating these in a polygon (tract, block, neighborhood, or other).
  
  - A buffer could be good to capture both distance and scale.
  
  - Park sizes definitely have more leverage imo, I imagine giant parks have more value than "pocket/block" parks.

- Crime Exposure

- Air Quality

- Flood Risk

- Noise Levels

- NDVI

- Topography (elevation or slope)

### Potential Interactions

- Square Feet * Walkability

  - Big unit premium grows with walkability.

- Noise * Park

  - Parks near high noise are less valuable.

- Square Feet * Downtown Proximity

  - Size premium decreases the further you move from center of the city.
  
**NOTE:** Depending on how large our regression model is, I think it could be good to keep it to 4 interactions or less.

## Diagnostics

- If we do interactions we need to center and scale the variables beforehand.

- VIF, make sure the values are lower than 5.

- Cross-Validation, 5-fold CV and train/test, look at out-of-sample RMSE vs in-sample residual SE.

- Could do a Moran's I of residuals, because if it's high then we could add neighborhood FE. Maybe look into spatial lag?
