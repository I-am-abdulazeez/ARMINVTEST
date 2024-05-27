const fs = require('fs');
const path = require('path');

// Folder you wanna look at
const folderPath = path.join(__dirname, 'Page');
const prefix = 'Pag';
const startingNumber = 52121000;

function renameAndModifyFiles(folderPath, prefix, startingNumber) {
  fs.readdir(folderPath, (err, files) => {
    if (err) {
      console.error('Error reading the directory:', err);
      return;
    }

    let currentNumber = startingNumber;

    files.forEach((file) => {
      const fileExtension = path.extname(file);

      // Skip files that contain 'dotnet' or have the extension '.xlf'
      if (
        file.toLowerCase().includes('dotnet') ||
        fileExtension.toLowerCase() === '.xlf'
      ) {
        console.log(`Skipping file: ${file}`);
        return;
      }

      const oldFilePath = path.join(folderPath, file);
      const fileNameWithoutExtension = path.basename(file, fileExtension);

      // Extract the actual name after "Table X - " part
      const nameMatch = fileNameWithoutExtension.match(/Page\s+\d+\s+-\s+(.*)/);
      if (!nameMatch) {
        console.error(`Skipping invalid file name format: ${file}`);
        return;
      }
      const newNamePart = nameMatch[1].trim();
      const newFileName = `${prefix}${currentNumber}.${newNamePart}.al`;
      const newFilePath = path.join(folderPath, newFileName);
      const fileNumber = currentNumber;

      // Read file content
      fs.readFile(oldFilePath, 'utf8', (err, data) => {
        if (err) {
          console.error('Error reading the file:', err);
          return;
        }

        // Modify file content, change you desire file content. For page, change to page
        const updatedData = data.replace(/page\s+\d+/, `page ${fileNumber}`);

        // Write modified content to new file
        fs.writeFile(newFilePath, updatedData, (err) => {
          if (err) {
            console.error('Error writing to the file:', err);
            return;
          }

          // Delete the old file
          fs.unlink(oldFilePath, (err) => {
            if (err) {
              console.error('Error deleting the old file:', err);
            } else {
              console.log(
                `Successfully renamed and modified ${file} to ${newFileName}`
              );
            }
          });
        });
      });

      currentNumber++;
    });
  });
}

renameAndModifyFiles(folderPath, prefix, startingNumber);
