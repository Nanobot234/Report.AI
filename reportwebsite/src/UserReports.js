import React, { useEffect, useState } from 'react';

const UserReports = () => {
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(true);

  // Fetch images and metadata from API
  useEffect(() => {
    const fetchImages = async () => {
      try {
        const response = await fetch('https://your-api-gateway-url/metadata');
        const data = await response.json();
        setImages(data); // Save fetched data to the state
        setLoading(false); // Set loading to false once data is fetched
      } catch (error) {
        console.error("Error fetching images:", error);
        setLoading(false); // Set loading to false even if there is an error
      }
    };

    fetchImages();
  }, []);

  if (loading) {
    return <p>Loading images...</p>;
  }

  return (
    <div className="gallery">
      {images.map((image) => (
        <div key={image.imageID} className="gallery-item">
          <img src={image.imageURL} alt={image.title} />
          <h3>{image.title}</h3>
          <p>{image.description}</p>
        </div>
      ))}
    </div>
  );
};

export default UserReports;
